# load the category names
cats = read.delim("~/Desktop/Personal/Speeches/sentiment/LIWC2007_Categories.txt", header=F)
row.names(cats) = cats$V1

# load the speech data
do = read.csv("~/Desktop/Personal/Speeches/Obama.txt", header=F)
dr <- read.csv("~/Desktop/Personal/Speeches/Romney.txt", header=F)

# normalize the dates of each data point
do$V1 = as.Date(as.character(do$V1), format='%Y%m%d')
dr$V1 = as.Date(as.character(dr$V1), format='%Y%m%d')
dmin = min(c(min(do$V1), min(dr$V1)))
do$V1 = as.integer(do$V1-dmin)
dr$V1 = as.integer(dr$V1-dmin)
dmin = 0
dmax = max(c(max(do$V1), max(dr$V1)))

# plot the angyness over time
t = 129
dot = do[do$V2==t, ]
drt = dr[dr$V2==t, ]
ymin = min(c(min(dot$V3), min(drt$V3)))
ymax = max(c(max(dot$V3), max(drt$V3)))
plot(V3 ~ V1, dot, xaxt = "n", type = "p", col='blue', xlab='Time', ylab='Frequency', ylim=c(ymin, ymax), xlim=c(0,dmax))
points(V3 ~ V1, drt, xaxt = "n", type = "p", col='red')

# save difference between averages for each category
comp=sapply(names(table(do$V2)), function (t) {
  c(t, mean(dr[dr$V2==as.integer(t), 'V3'])-mean(do[do$V2==as.integer(t), 'V3']))
})
comp=t(comp)
comp=merge(comp, cats, by.x='V1', by.y='V1')
names(comp) = c('id', 'weight', 'name')
comp=comp[order(comp[,2]), ]
