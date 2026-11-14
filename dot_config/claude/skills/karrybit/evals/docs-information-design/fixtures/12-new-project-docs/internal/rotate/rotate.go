package rotate

import (
	"os"
	"path/filepath"
	"time"
)

type Options struct {
	Dir      string
	Pattern  string
	MaxAge   time.Duration
	Compress bool
	DryRun   bool
	Now      time.Time
}

// Sweep processes regular files directly inside Dir (it does not recurse).
// Files already ending in .gz are skipped so repeated runs are idempotent.
// Age is judged by modification time.
func Sweep(o Options) (int, error) {
	entries, err := os.ReadDir(o.Dir)
	if err != nil {
		return 0, err
	}
	n := 0
	for _, e := range entries {
		if !e.Type().IsRegular() || filepath.Ext(e.Name()) == ".gz" {
			continue
		}
		if ok, _ := filepath.Match(o.Pattern, e.Name()); !ok {
			continue
		}
		info, err := e.Info()
		if err != nil {
			return n, err
		}
		if o.Now.Sub(info.ModTime()) < o.MaxAge {
			continue
		}
		path := filepath.Join(o.Dir, e.Name())
		if o.DryRun {
			printAction(path, o.Compress)
		} else if o.Compress {
			err = gzipAndRemove(path)
		} else {
			err = os.Remove(path)
		}
		if err != nil {
			return n, err
		}
		n++
	}
	return n, nil
}
