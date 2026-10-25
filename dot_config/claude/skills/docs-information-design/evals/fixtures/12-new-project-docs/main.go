// Command logsweep deletes or gzips log files older than a cutoff.
package main

import (
	"flag"
	"fmt"
	"os"
	"time"

	"github.com/example/logsweep/internal/rotate"
)

func main() {
	dir := flag.String("dir", "", "directory to sweep (required)")
	pattern := flag.String("pattern", "*.log", "glob matched against file names")
	maxAge := flag.Duration("max-age", 7*24*time.Hour, "files older than this are processed")
	compress := flag.Bool("compress", false, "gzip old files instead of deleting them")
	dryRun := flag.Bool("dry-run", false, "print actions without changing files")
	flag.Parse()

	if *dir == "" {
		fmt.Fprintln(os.Stderr, "logsweep: -dir is required")
		os.Exit(2)
	}
	n, err := rotate.Sweep(rotate.Options{
		Dir: *dir, Pattern: *pattern, MaxAge: *maxAge,
		Compress: *compress, DryRun: *dryRun, Now: time.Now(),
	})
	if err != nil {
		fmt.Fprintln(os.Stderr, "logsweep:", err)
		os.Exit(1)
	}
	fmt.Printf("logsweep: %d files processed\n", n)
}
