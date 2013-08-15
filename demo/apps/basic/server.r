shinyServer(function(input, output, session) {
  # Create a slider that's used for two different plots
  span_slider <- input_slider(min = 0.2, max = 1, value = 0.5, step = 0.05,
    label = "Loess span")

  # Create the gigvis objects
  gv <- reactive({
    gigvis(mtcars, props(x ~ wt, y ~ mpg),
      mark_symbol(),
      branch_smooth(span = span_slider)
    )
  })
  gv2 <- reactive({
    gigvis(mtcars, props(x ~ wt, y ~ hp),
      mark_symbol(),
      branch_smooth(span = span_slider)
    )
  })

  # Set up observers for the spec and the data
  observeGigvis(gv, "plot1", session)
  observeGigvis(gv2, "plot2", session, width = 250, height = 250)

  # User interface elements (in the sidebar)
  output$gigvis_ui <- renderControls(gv, session)

  # Stop the app when the quit button is clicked
  observe({
    if (is.null(input$quit)) return()
    if (input$quit > 0) stopApp()
  })

})
