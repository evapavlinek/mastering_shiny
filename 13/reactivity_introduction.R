library(shiny)
reactiveConsole(TRUE)

# A reactive expression has two important properties:
#   It’s lazy: it doesn’t do any work until it’s called.
#   It’s cached: it doesn’t do any work the second and subsequent times it’s called because it 
#   caches the previous result.

temp_c <- reactiveVal(10) # create
temp_c()                  # get
temp_c(20)                # set
temp_c()                  # get

temp_f <- reactive({
  message("Converting") 
  (temp_c() * 9 / 5) + 32
})
temp_f()

# a reactive expression automatically tracks all of its dependencies. So that later, 
# if temp_c changes, temp_f will automatically update
temp_c(-3)
temp_c(-10)
temp_f()

# But if temp_c() hasn’t changed, then temp_f() doesn’t need to recompute43, 
# and can just be retrieved from the cache ("Converting" is not printed)
temp_f()
