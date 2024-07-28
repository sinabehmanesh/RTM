package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	cmd "main/command"
	db "main/database"
)

func main() {
	if len(os.Args) <= 1 {
		log.Fatal("Wrong input. Run rtm --help")
	}

	local_db := db.Check_database()

	args := os.Args[1:]
	command := args[0]

	switch command {
	case "status":
		cmd.Check_status(local_db)
	case "add":
		task := strings.Join(os.Args[1:], " ")
		cmd.Add_task(task)
	case "del", "rm":
		task_id := os.Args[1]
		cmd.Delete_task(task_id)
	case "done":
		task_id := os.Args[1]
		cmd.Done_task(task_id)
	case "--help", "help", "-h":
		cmd.Help()
	default:
		fmt.Println("Please provide a proper input.")
		fmt.Println("Type rtm --help for help")
	}
}
