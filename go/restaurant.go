package main

import (
	"log"
	"math/rand"
	"sync"
	"time"
	"sync/atomic"
)
func logAction(action ...any) {
	log.Println(action...)
}
func do(seconds int, action ...any) {
	logAction(action...)
	randomMillis := 500*seconds + rand.Intn(500*seconds)
	time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}
type Order struct {
	id        uint64
	customer  string
	preparedBy string
	reply     chan *Order
}
var nextId atomic.Uint64
//3 outstanding orders
var Waiter = make(chan *Order, 3)
func Cook(name string) {
	logAction(name, "starting work")
	for order := range Waiter {
		do(10, name, "cooking order", order.id, "for", order.customer)
		order.preparedBy = name
		order.reply <- order
	}
}
func Customer(name string, wg *sync.WaitGroup) {
	defer wg.Done()
	mealsEaten := 0
	for mealsEaten < 5 {
		order := &Order{
			id:       nextId.Add(1),
			customer: name,
			reply:    make(chan *Order, 1),
		}
		logAction(name, "placed order", order.id)
		select {
		case Waiter <- order:
			select {
			case completedOrder := <-order.reply:
				do(2, name, "eating cooked order", completedOrder.id, "prepared by", completedOrder.preparedBy)
				mealsEaten++
			}
		case <-time.After(7 * time.Second):
			do(5, name, "waited too long, abandoning order", order.id)
		}
	}
	logAction(name, "finished dining and is going home")
}
func main() {
	rand.Seed(time.Now().UnixNano())
	customers := []string{"Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai"}
	var wg sync.WaitGroup
	go Cook("Remy")
	go Cook("Colette")
	go Cook("Linguini")
	for _, name := range customers {
		wg.Add(1)
		go Customer(name, &wg)
	}
	wg.Wait()
	logAction("The restaurant is closing for the day")
}
