# Building a Prod-Ready, Robust Shiny Application.
# 
# Each step is optional. 
# 
# 1 - On init
# 
## 1.1 - Fill the descripion & set options
## 
## Add information about the package that will contain your app

golem::fill_desc(
  pkg_name = "mapdO", # The Name of the package containing the App 
  pkg_title = "mapdO: exploration de données fluviales", # The Title of the package containing the App  
  pkg_description="Blabla. Blabla.",
  author_first_name = "Lise", # Your First Name
  author_last_name = "Vaudor",  # Your Last Name
  author_email = "lise.vaudor@ens-lyon.fr",      # Your Email
  repo_url = NULL # The (optional) URL of the GitHub Repo
)     

## Use this desc to set {golem} options

golem::set_golem_options()

## 1.2 - Set common Files 
## 
## If you want to use the MIT licence, README, code of conduct, lifecycle badge, and news

usethis::use_mit_license( name = "Golem User" )  # You can set another licence here
usethis::use_readme_rmd( open = FALSE )
usethis::use_code_of_conduct()
usethis::use_lifecycle_badge( "Experimental" )

usethis::use_news_md( open = FALSE )
usethis::use_git()
usethis::use_vignette("guidelines")
## 1.3 - Add a data-raw folder
## 
## If you have data in your package
usethis::use_data( name = "datasets", open = FALSE ) # Change "my_dataset"

## 1.4 - Init Tests
## 
## Create a template for tests

golem::use_recommended_tests()

## 1.5 : Use Recommended Package

golem::use_recommended_deps()

## 1.6 Add various tools

# If you want to change the favicon (default is golem's one)
golem::remove_favicon()
golem::use_favicon("inst/app/www/mapdO.png") # path = "path/to/ico". Can be an online file. 

# Add helper functions 
golem::use_utils_ui()
golem::use_utils_server()

# You're now set! 
# go to dev/02_dev.R
rstudioapi::navigateToFile( "dev/02_dev.R" )

