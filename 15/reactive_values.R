library(shiny)
reactiveConsole(TRUE)

x <- reactiveVal(10)
x()       # get
x(20)     # set
x()       # get

r <- reactiveValues(x = 10)
r$x       # get
r$x <- 20 # set
r$x       # get


a1 <- a2 <- 10
a2 <- 20
a1 # unchanged

b1 <- b2 <- reactiveValues(x = 10)
b1$x <- 20
b2$x # changed




# 15.1.1.1 What are the differences between these two lists of reactive values? 
# ompare the syntax for getting and setting individual reactive values.
l1 <- reactiveValues(a = 1, b = 2)
l2 <- list(a = reactiveVal(1), b = reactiveVal(2))

l1
l2
l1$a
l2$a
l2$a()


# 15.1.1.2 Design and perform a small experiment to verify that reactiveVal() also has 
# reference semantics.
a1 <- a2 <- reactiveVal(10)
a1()
a2()
a2(20)
a1() 
a2()




y <- reactiveVal(10)
observe({
  message("`y` is ", y())
})
y(5)
y(4)



x <- reactiveVal(1)
y <- observe({
  x()
  observe(print(x()))
})
x(2)
x(3)
x(2)



# an infinite loop:
r <- reactiveValues(count = 0, x = 1)
observe({
  r$x
  r$count <- r$count + 1
})


# without taking a dependency:
r <- reactiveValues(count = 0, x = 1)
class(r)
observe({
  r$x
  r$count <- isolate(r$count) + 1
})

r$x <- 1
r$x <- 2
r$count

r$x <- 3
r$count

