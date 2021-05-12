package main

import (
	"fmt"
	"time"
	"context"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/aws/endpoints"
)

func main() {
	currentTime := time.Now()

	var timeout time.Duration

	s := session.Must(session.NewSession(&aws.Config{
		Region: aws.String(endpoints.SaEast1RegionID),
	}))
	svc := s3.New(s)

	ctx := context.Background()
	var cancelFn func()
	if timeout > 0 {
		ctx, cancelFn = context.WithTimeout(ctx, timeout)
	}
	if cancelFn != nil {
		defer cancelFn()
	}

	result, err := svc.ListBuckets(nil)
	if err != nil {
		fmt.Println(err)
	}
	for _, bucket := range result.Buckets {
		fmt.Printf("Bucket Name :: %s\n", *bucket.Name)
	}

	fmt.Println("[INFO] Listing Buckets Done", currentTime.Format("2006.01.02 15:04:05"))
}
