## [[file:~/git/finding_trees/finding_trees.org::*load%20libraries][load libraries:1]]
library(devtools)
# need the development version (as of [2019-10-18 Fri]) to get the point_metrics function.
# the point metrics function is likely to change when released into the stable version which will probably break this code
# but I hope the concept remains the same.
  install_github("Jean-Romain/lidR", ref = "devel")
    library(lidR) 
    library(rgl)
    pct_x_is<- function(x, is) {
        return(list(pct_x = sum(x == is) / length(x)))
        }
## load libraries:1 ends here

## [[file:~/git/finding_trees/finding_trees.org::*look%20at%20the%20example%20lidar%20point%20cloud.%202016%20lidar%20from%20Madison,%20WI][look at the example lidar point cloud.  2016 lidar from Madison, WI:1]]
l <- readLAS("test2016.las", filter = "-drop_z_below 6 -keep_first")
plot(l)
lw <- rglwidget()
htmlwidgets::saveWidget(lw, "height.html")
## look at the example lidar point cloud.  2016 lidar from Madison, WI:1 ends here

## [[file:~/git/finding_trees/finding_trees.org::*find%20coplanar%20points%20and%20call%20them%20"building"][find coplanar points and call them "building":1]]
lsp <- lasdetectshape(l, shp_plane(th1 = 4, th2 = 4, k = 10), "building")
plot(lsp, color = "building", col = c("green", "red"))
## find coplanar points and call them "building":1 ends here

## [[file:~/git/finding_trees/finding_trees.org::*Use%20=point_metrics=][Use =point_metrics=:1]]
pm <- point_metrics(lsp, ~pct_x_is(x = building, is = TRUE), k = 50)

# uncomment this bit of code if you'd like to see what the "percent building" looks like.
#  lsp <- lasadddata(lsp, pm$pct_x, "pct_x")
#  plot(lsp, color = "pct_x", trim = 1)

  lsp@data$building[pm$pct_x > .6] <- TRUE
  lsp@data$building[pm$pct_x < .4] <- FALSE
  plot(lsp, color = "building", col = c("green", "red"))
## Use =point_metrics=:1 ends here

## [[file:~/git/finding_trees/finding_trees.org::*Try%20to%20remove%20powerlines%20and%20tower%20using%20colinear%20shape%20detection][Try to remove powerlines and tower using colinear shape detection:1]]
lf <- lasfilter(lsp, building == FALSE)
lfl <- lasdetectshape(lf, shp_line(th1 = 4, k = 15), "building")
plot(lfl, color = "building")
## Try to remove powerlines and tower using colinear shape detection:1 ends here

## [[file:~/git/finding_trees/finding_trees.org::*Try%20to%20remove%20powerlines%20and%20tower%20using%20colinear%20shape%20detection][Try to remove powerlines and tower using colinear shape detection:2]]
pm <- point_metrics(lfl, ~pct_x_is(x = building, is = TRUE), k = 30)

lfl@data$building[pm$pct_x > .4] <- TRUE
lfl@data$building[pm$pct_x < .1] <- FALSE
plot(lfl, color = "building", col = c("green", "red"))
lf <- lasfilter(lfl, building == FALSE)

plot(lf)
## Try to remove powerlines and tower using colinear shape detection:2 ends here

## [[file:~/git/finding_trees/finding_trees.org::*Try%20to%20remove%20powerlines%20and%20tower%20using%20colinear%20shape%20detection][Try to remove powerlines and tower using colinear shape detection:3]]
treesw <- rglwidget()
htmlwidgets::saveWidget(treesw, "trees.html")
## Try to remove powerlines and tower using colinear shape detection:3 ends here
