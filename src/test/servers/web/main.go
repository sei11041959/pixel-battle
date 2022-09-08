package main

import (
	"io"
	"log"
	"net/http"
)

func hogeHandler(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, `hello`)
}

func main() {
	http.HandleFunc("/hoge", hogeHandler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
