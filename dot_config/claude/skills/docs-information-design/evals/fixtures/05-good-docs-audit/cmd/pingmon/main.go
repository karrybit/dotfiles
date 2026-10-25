package main

import (
	"flag"
	"log"
	"time"
)

func main() {
	targets := flag.String("targets", "targets.txt", "file with one host per line")
	interval := flag.Duration("interval", 30*time.Second, "probe interval")
	listen := flag.String("listen", ":9101", "address for the /metrics endpoint")
	flag.Parse()

	if err := run(*targets, *interval, *listen); err != nil {
		log.Fatal(err)
	}
}
