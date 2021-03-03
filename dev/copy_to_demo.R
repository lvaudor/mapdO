copy_to_demo=function(demo_name="demo"){
      path_mapdO="/data/user/v/lvaudor/zPublish/shiny/mapdO/"
      path_demo=paste0("/data/user/v/lvaudor/zPublish/shiny/mapdO_",demo_name,"/")
      #file.remove(path_demo,recursive=TRUE)
      R.utils::copyDirectory(from=paste0(path_mapdO,"inst"),
                             to=paste0(path_demo,"inst"))
      R.utils::copyDirectory(from=paste0(path_mapdO,"data_AXES"),
                             to=paste0(path_demo,"data_AXES"))
      file.copy(from=paste0(path_mapdO,"app.R"),
                to=  paste0(path_demo,"app.R"),
                overwrite=TRUE)
}
copy_to_demo("demo1")
