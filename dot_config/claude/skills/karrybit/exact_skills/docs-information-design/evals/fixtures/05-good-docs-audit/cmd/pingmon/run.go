package main

import (
	"net/http"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	up = prometheus.NewGaugeVec(prometheus.GaugeOpts{
		Name: "pingmon_up", Help: "1 if the last probe got a reply",
	}, []string{"target"})
	rtt = prometheus.NewGaugeVec(prometheus.GaugeOpts{
		Name: "pingmon_rtt_seconds", Help: "RTT of the last successful probe",
	}, []string{"target"})
)

func run(targetsFile string, interval time.Duration, listen string) error {
	prometheus.MustRegister(up, rtt)
	targets, err := readTargets(targetsFile) // skips blank lines and lines starting with '#'
	if err != nil {
		return err
	}
	go probeLoop(targets, interval)
	http.Handle("/metrics", promhttp.Handler())
	return http.ListenAndServe(listen, nil)
}
