package main

import (
	"fmt"
	"net/http"
	"os"
)

func enableCors(w *http.ResponseWriter) {
	(*w).Header().Set("Access-Control-Allow-Origin", "*")
}

func main() {
	// Print startup
	fmt.Println("Starting API server...")

	http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "OK")
	})

	http.HandleFunc("/livez", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "OK")
	})

	http.HandleFunc("/download", func(w http.ResponseWriter, r *http.Request) {
		// Check DOWNLOAD_ENABLED environment variable
		if os.Getenv("DOWNLOAD_ENABLED") != "true" {
			fmt.Fprintf(w, "Download is disabled")
			return
		}

		enableCors(&w)
		// Return a CSV list of invoices
		w.Header().Set("Content-Type", "text/csv")
		// Make a browser download it as a file
		w.Header().Set("Content-Disposition", "attachment;filename=invoices.csv")
		fmt.Fprintf(w, "Invoice Number,Invoice Date,Invoice Amount\n")
		fmt.Fprintf(w, "1001,2019-01-01,100.00\n")
		fmt.Fprintf(w, "1002,2019-01-02,200.00\n")
		fmt.Fprintf(w, "1003,2019-01-03,300.00\n")
	})

	http.ListenAndServe(":8080", nil)
}
