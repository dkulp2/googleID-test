library(shiny)
library(googleAuthR)
library(googleID)

## set your web app client ID/secret and scopes
options(googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/userinfo.email",
                                        "https://www.googleapis.com/auth/userinfo.profile"))

options(googleAuthR.webapp.client_id = "214969242318-gj38kn0nhhnp6ie4798ab88155s8036c.apps.googleusercontent.com",
        googleAuthR.webapp.client_secret = "nSzVED0znublCSiTdgyt4hKD")

ui <- fluidPage(
  sidebarLayout(
             sidebarPanel(
               p("Welcome!"),
               googleAuthUI("gauth_login")
             ),
             mainPanel(
               textOutput("display_username")
             )
           )
)

server <- function(input, output, session) {
  ## Authentication
  accessToken <- callModule(googleAuth, "gauth_login",
                            login_class = "btn btn-primary",
                            logout_class = "btn btn-primary")
  userDetails <- reactive({
    validate(
      need(accessToken(), "not logged in")
    )
    with_shiny(get_user_info, shiny_access_token = accessToken())
  })
  
  ## Display user's Google display name after successful login
  output$display_username <- renderText({
    validate(
      need(userDetails(), "getting user details")
    )
    userDetails()$displayName
  })
  
}

shinyApp(ui = ui, server = server)