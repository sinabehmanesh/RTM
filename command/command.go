package command

import (
	"fmt"
)

func Help() {
	fmt.Println("------")
	fmt.Println(" rtm [Option] [Command]")
	fmt.Println("\n \t\t status \t\t Get the status of your tasks \t")
	fmt.Println("\t\t add [TASK DESCRIPTION]\t Add tasks with name/description")
	fmt.Println("\t\t del, rm [ID] \t\t Delete tasks by ID")
	fmt.Println("\t\t done [ID] \t\t Update task status from todo to Done")
	fmt.Println("\t\t export \t\t export tasks into a file, file format: [dump]-[RFC date]")
}
