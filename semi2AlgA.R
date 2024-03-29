source("modifyM.R")

library(grid)
plotLabyrinth <- function(lab)
{
	sel <- lab[,] == -1
	lab[sel] <- rgb(0, 0, 0)		
	
	sel <- lab[,] == 0
	lab[sel] <- rgb(1, 1, 1)

	sel <- lab[,] == -2
	lab[sel] <- rgb(1, 0, 0)

	sel <- lab[,] == -3
	lab[sel] <- rgb(1, 1, 0)
	
	sel <- lab[,] == -4
	lab[sel] <- rgb(0, 0, 1)

	sel <- lab[,] == -5
	lab[sel] <- rgb(0, 1, 0)

	sel <- lab[,] == 1
	lab[sel] <- rgb(0.3, 0.3, 0.3)

	sel <- lab[,] == 2
	lab[sel] <- rgb(0.4, 0.4, 0.4)

	sel <- lab[,] == 3
	lab[sel] <- rgb(0.6, 0.6, 0.6)

	sel <- lab[,] == 4
	lab[sel] <- rgb(0.8, 0.8, 0.8)

	grid.newpage()
	grid.raster(lab, interpolate=F)
}


mainA <- function(data,currentPosition){
	pathFound=FALSE
	Sys.sleep(0.01)
	rowNum=c(1,.Machine$integer.max)
	if (is.vector(currentPosition)) currentPosition=matrix(currentPosition,ncol=3)
	for(i in 1:nrow(currentPosition)){	
		dol=data[currentPosition[i,1]+1,currentPosition[i,2]]
		desno=data[currentPosition[i,1],currentPosition[i,2]+1]
		gor=data[currentPosition[i,1]-1,currentPosition[i,2]]
		levo=data[currentPosition[i,1],currentPosition[i,2]-1]

		x=c(dol,desno,gor,levo)
		smer=which.max(1 / x)
		rez=currentPosition[i,3]+x[smer]

		if (any(-3 == x)){
			rowNum[1]=i
			rowNum[2]=rez
			break
		}

		if (rowNum[2] > rez){
			rowNum[1]=i
			rowNum[2]=rez
		}
	}

	i=rowNum[1]
	data[currentPosition[i,1],currentPosition[i,2]]=-4
	screen <- plotLabyrinth(data)
	dol=data[currentPosition[i,1]+1,currentPosition[i,2]]
	desno=data[currentPosition[i,1],currentPosition[i,2]+1]
	gor=data[currentPosition[i,1]-1,currentPosition[i,2]]
	levo=data[currentPosition[i,1],currentPosition[i,2]-1]
	
	x=c(dol,desno,gor,levo)
	smer=which.max(1 / x)
	
	if (any(x==-3))
		data[currentPosition[i,1],currentPosition[i,2]]=-5
	nextPosition=c()
	if (dol == -3) return(data)
	if (dol >= 0){
		if (smer==1){
			nextPosition[length(nextPosition)+1]=currentPosition[i,1]+1
			nextPosition[length(nextPosition)+1]=currentPosition[i,2]
			nextPosition[length(nextPosition)+1]=currentPosition[i,3]+dol
			data[currentPosition[i,1]+1,currentPosition[i,2]] = -2
			screen <- plotLabyrinth(data)
		}
		else{
			nextPosition[length(nextPosition)+1]=currentPosition[i,1]+1
			nextPosition[length(nextPosition)+1]=currentPosition[i,2]
			nextPosition[length(nextPosition)+1]=currentPosition[i,3]
			data[currentPosition[i,1]+1,currentPosition[i,2]] = -2
			screen <- plotLabyrinth(data)
		}
	}
	if (desno == -3) return(data)
	if (desno >= 0){
		if (smer==2){
			nextPosition[length(nextPosition)+1]=currentPosition[i,1]
			nextPosition[length(nextPosition)+1]=currentPosition[i,2]+1
			nextPosition[length(nextPosition)+1]=currentPosition[i,3]+desno
			data[currentPosition[i,1],currentPosition[i,2]+1] = -2
			screen <- plotLabyrinth(data)
		}
		else{
			nextPosition[length(nextPosition)+1]=currentPosition[i,1]
			nextPosition[length(nextPosition)+1]=currentPosition[i,2]+1
			nextPosition[length(nextPosition)+1]=currentPosition[i,3]
			data[currentPosition[i,1],currentPosition[i,2]+1] = -2
			screen <- plotLabyrinth(data)
		}
	}
	if (gor == -3) return(data)
	if (gor >= 0){
		if (smer==3){
			nextPosition[length(nextPosition)+1]=currentPosition[i,1]-1
			nextPosition[length(nextPosition)+1]=currentPosition[i,2]
			nextPosition[length(nextPosition)+1]=currentPosition[i,3]+gor
			data[currentPosition[i,1]-1,currentPosition[i,2]] = -2
			screen <- plotLabyrinth(data)
		}
		else{
			nextPosition[length(nextPosition)+1]=currentPosition[i,1]-1
			nextPosition[length(nextPosition)+1]=currentPosition[i,2]
			nextPosition[length(nextPosition)+1]=currentPosition[i,3]
			data[currentPosition[i,1]-1,currentPosition[i,2]] = -2
			screen <- plotLabyrinth(data)
		}
	}
	if (levo == -3) return(data)
	if (levo >= 0){
		if (smer==4){
			nextPosition[length(nextPosition)+1]=currentPosition[i,1]
			nextPosition[length(nextPosition)+1]=currentPosition[i,2]-1
			nextPosition[length(nextPosition)+1]=currentPosition[i,3]+levo
			data[currentPosition[i,1],currentPosition[i,2]-1] = -2
			screen <- plotLabyrinth(data)
		}
		else{
			nextPosition[length(nextPosition)+1]=currentPosition[i,1]
			nextPosition[length(nextPosition)+1]=currentPosition[i,2]-1
			nextPosition[length(nextPosition)+1]=currentPosition[i,3]
			data[currentPosition[i,1],currentPosition[i,2]-1] = -2
			screen <- plotLabyrinth(data)
		}
	}
	
	
	if (nrow(currentPosition) > 1 ){
		nextPosMx=currentPosition[-i,]
		if (length(nextPosition) > 0)
			nextPosMx=rbind(nextPosMx,t(matrix(c(nextPosition), nrow=3)))
	}else{
		if (length(nextPosition) > 0)
			nextPosMx=t(matrix(c(nextPosition), nrow=3))
		else
			return(data)
	}
	if (!pathFound)
		kt=mainA(data,nextPosMx)
	if (is.matrix(kt)) data=kt

	if (smer == 1 && data[currentPosition[i,1]+1,currentPosition[i,2]] == -5 ||
	    smer == 2 && data[currentPosition[i,1],currentPosition[i,2]+1] == -5 ||
	    smer == 3 && data[currentPosition[i,1]-1,currentPosition[i,2]] == -5 ||
	    smer == 4 && data[currentPosition[i,1],currentPosition[i,2]-1] == -5)
		data[currentPosition[i,1],currentPosition[i,2]]=-5
	else if(data[currentPosition[i,1]+1,currentPosition[i,2]] == -5 ||
		  data[currentPosition[i,1],currentPosition[i,2]+1] == -5 ||
		  data[currentPosition[i,1]-1,currentPosition[i,2]] == -5 ||
		  data[currentPosition[i,1],currentPosition[i,2]-1] == -5)
		data[currentPosition[i,1],currentPosition[i,2]]=-5
	
	screen <- plotLabyrinth(data)
	return(data)
}

getPath<- function(data,cp){
	pathData=cp
	dol=data[cp[1]+1,cp[2]]
	desno=data[cp[1],cp[2]+1]
	gor=data[cp[1]-1,cp[2]]
	levo=data[cp[1],cp[2]-1]

	x=c(dol,desno,gor,levo)
	
	if(dol == -5)
		cp[1]=cp[1]+1
	else if(desno == -5)
		cp[2]=cp[2]+1
	else if(gor == -5)
		cp[1]=cp[1]-1
	else if(levo == -5)
		cp[2]=cp[2]-1
	if (!any(x==-5)){
		data[pathData[1],pathData[2]]=-4
		if(dol == -3)
			cp[1]=cp[1]+1
		else if(desno == -3)
			cp[2]=cp[2]+1
		else if(gor == -3)
			cp[1]=cp[1]-1
		else if(levo == -3)
			cp[2]=cp[2]-1
		return(rbind(pathData,cp))
	}
	
	data[pathData[1],pathData[2]]=-4
	return(rbind(pathData,getPath(data,cp)))
}

getPoints<- function(data,matrix){
	points=0
	for(i in 3:nrow(matrix)-1){
		points=points+data[matrix[i,1],matrix[i,2]]	
	}
	return(points)
}

Azvezda<- function(data,currPos){
	data=mainA( data,matrix( c(currPos,0), ncol=3 ) )
	return(getPath(data,currPos))
}

data <- read.table("labyrinth_1.txt", sep=",", header=F)
data <- as.matrix(data)
screen <- plotLabyrinth(data)

a=Azvezda(data,which(data == -2, TRUE))
getPoints(data,a)
print(paste("Stevilo vozlisc na poti:", nrow(a)))
setsOfCoords(a)
