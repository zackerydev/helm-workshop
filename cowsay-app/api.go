package main

import (
	"fmt"
	"net/http"
	"strings"
)

const asciiArt = `
  _____
< Moo! >
  -----
         \   ^__^
          \  (oo)\_________
             (__)\   C2FO  )\/\
                 ||------w |
                 ||       ||
`

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Println("speak cow!")
	text := r.URL.Query().Get("text")
	if text == "" {
		text = "Moo!"
	}
	// combine the ascii art with the text
	replaced := strings.Replace(asciiArt, "Moo!", text, -1)

	// write the ascii art to the response
	fmt.Fprint(w, replaced)
}

func main() {
	fmt.Println("app started")

	// Dont think we need this, but in case we do, here it is
	// http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
	// 	// The "/" pattern matches everything, so we need to check
	// 	// that we're at the root here.
	// 	if req.URL.Path != "/" {
	// 		http.NotFound(w, req)
	// 		return
	// 	}

	// 	handler(w, req)
	// })

	http.HandleFunc("/cowsay", handler)

	http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("healthz called")
		fmt.Fprintf(w, "OK")
	})

	http.HandleFunc("/livez", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("livez called")
		fmt.Fprintf(w, "OK")
	})

	http.ListenAndServe(":8080", nil)
}
