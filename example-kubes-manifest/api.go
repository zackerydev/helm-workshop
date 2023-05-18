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
          \  (oo)\_______
             (__)\       )\/\
                 ||----w |
                 ||     ||
`

func handler(w http.ResponseWriter, r *http.Request) {
	text := r.URL.Query().Get("text")
	if text == "" {
		text = "Moo!"
	}
	// combine the ascii art with the text
	// asciiArt := fmt.Sprintf("%s\n%s", asciiArt, text)
	replaced := strings.Replace(asciiArt, "Moo!", text, -1)

	// write the ascii art to the response
	fmt.Fprint(w, replaced)
}

func main() {
	http.HandleFunc("/", handler)
	http.HandleFunc("/cowsay", handler)
	http.ListenAndServe(":8080", nil)
}
