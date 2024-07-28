package command

import "fmt"

func Check_status() {
	fmt.Println("this will check tasks")
}

func Add_task(task string) {
	fmt.Println("Task:", task, "added")
}

func Delete_task(id string) {
	fmt.Println("Task:", id, "Deleted")
}

func Done_task(id string) {
	fmt.Println("Task:", id, "is now Done")
}

func Help() {
	fmt.Println("------")
	fmt.Println(" rtm [Option] [Command]")
	fmt.Println("\n \t\t status \t\t Get the status of your tasks \t")
	fmt.Println("\t\t add [TASK DESCRIPTION]\t Add tasks with name/description")
	fmt.Println("\t\t del, rm [ID] \t\t Delete tasks by ID")
	fmt.Println("\t\t done [ID] \t\t Update task status from todo to Done")
}
