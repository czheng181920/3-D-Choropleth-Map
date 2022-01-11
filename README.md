# 3-D-Choropleth-Map

This data visualization project uses R to model cancer disparities as 3-D, interactive graphs. Data was sourced from the Ohio Department of Health and the United States Cancer Statistics to contrast sex-specific colorectal cancer incidence rates across Ohio counties.


Small note: to create a constantly rotating movie of the 3-D graphs use the following code:

```
render_movie("movie_incidence.mp4",frames = 720, fps=30,zoom=0.6,fov = 30,
             type = oscillate)

filename_movie = tempfile()
render_movie(filename = filename_movie, 
            frames = 130,  phi = 45, zoom = 0.8, theta = -90)
```
Acknowledgements: Special thanks to Dr. Schumacher for mentoring me this summer on this project and thanks to Dr. Berger and all those involved with the SEO program. 
