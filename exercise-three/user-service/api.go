package main

import (
	"fmt"
	"net/http"
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

	http.HandleFunc("/users", func(w http.ResponseWriter, r *http.Request) {
		enableCors(&w)
		// Return JSON data
		// Set application/json header
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintf(w, "{\"users\":[{\"name\":\"Luke\"},{\"name\":\"Obi-Wan\"}]}")
	})

	http.ListenAndServe(":8080", nil)
}
