package main

import (
	"context"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/brianvoe/gofakeit"
	"time"
)

func main() {
	run()
}

func run() {
	ctx := context.Background()
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		panic(err)
	}

	dclient := dynamodb.NewFromConfig(cfg)
	for i := 0; i < 100; i++ {
		t := &Transaction{
			ID:            gofakeit.UUID(),
			TransactionID: gofakeit.UUID(),
			PostedDate:    gofakeit.Date(),
			PostedAmount:  gofakeit.Price(-500.25, 2500.15),
			Description:   gofakeit.Sentence(5),
		}

		av, err := attributevalue.MarshalMap(t)
		if err != nil {
			panic(err)
		}
		_, err = dclient.PutItem(ctx, &dynamodb.PutItemInput{
			Item:      av,
			TableName: aws.String("transaction-store"),
		})

		if err != nil {
			panic(err)
		}

		go secondHalf(t, dclient)

	}
}

func secondHalf(t *Transaction, c *dynamodb.Client) {
	t.SubcategoryName = gofakeit.Color()
	t.CategoryName = gofakeit.BeerStyle()
	t.MerchantName = gofakeit.Company()
	t.Publishable = aws.Bool(true)
	av, err := attributevalue.MarshalMap(t)
	if err != nil {
		panic(err)
	}
	_, err = c.PutItem(context.Background(), &dynamodb.PutItemInput{
		Item:      av,
		TableName: aws.String("transaction-store"),
	})

	if err != nil {
		panic(err)
	}

}

type Transaction struct {
	ID            string    `dynamodbav:"accountid"`
	TransactionID string    `dynamodbav:"transactionid"`
	PostedDate    time.Time `dynamodbav:"posteddate"`
	PostedAmount  float64   `dynamodbav:"postedamount"`
	Description   string    `dynamodbav:"description"`
	OtherTransactionHalf
	Publishable *bool `dynamodbav:"publishable"`
}

type OtherTransactionHalf struct {
	MerchantName    string `dynamodbav:"merchantname"`
	CategoryName    string `dynamodbav:"categoryname"`
	SubcategoryName string `dynamodbav:"subcategoryname"`
}
