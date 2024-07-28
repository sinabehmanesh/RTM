package main

import (
	"fmt"
	"os"
)

func main() {
	fmt.Println("hey lads how are you!")
	args := os.Args[1:]

	fmt.Println(args)
	command := args[0]

	switch command {
	case "add":
		fmt.Println("this is add command")
	case "status":
		fmt.Println("this is a status command")
	case "del", "rm":
		fmt.Println("this is a delete command")
	case "done":
		fmt.Println("this is a done command")
	}
}
