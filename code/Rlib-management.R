# Manages the packages in the local library
#There is also http://rstudio.github.io/packrat/, but that seems like over-kill
# and I think it stores a lot of machine-specific info so not very 
# version control safe.

source("code/R_utils.R")
.libPaths(paste0(getwd(),"/code/Rlib"))

#This was ripped from repmis::InstallOldPackages 0.4. Don't need the package overhead
InstallOldPackage <- function(pkg, version,
															 oldRepos = "http://cran.r-project.org", lib = NULL)
{
	reposClean <- gsub("/", "\\/", oldRepos)
	
	available <- available.packages(contriburl =
																		contrib.url(repos = "http://cran.us.r-project.org", type = "source"))
	available <- data.frame(unique(available[, c("Package", "Version")]))
	names(available) <- c("pkg", "version")
	available$pkg <- as.character(available$pkg)
	available$version <- as.character(available$version)
	tframe = data.frame(pkg, version)
	Matched <- merge(tframe, available, all = FALSE)
	if (nrow(Matched) == 1){
		newpack <- as.character(Matched[, 1])
		install.packages(newpack, lib = lib)
	} else if (nrow(Matched) == 0){
		from <- paste0(reposClean, "/src/contrib/Archive/", pkg, "/", pkg, "_", version, ".tar.gz")
		TempFile <- paste0(pkg, "_", version, ".tar.gz")
		download.file(url = from, destfile = TempFile)
		install.packages(TempFile, repos = NULL, type = "source", lib = lib)
		unlink(TempFile)
	}
}

# Ideally this functions could work out the dependencies between packages
# but that's a lot of work, so the pkglist should be hand-editted
# (if you are using Rstudio you can edit a matrix with x = edit(x))
# with the ordering that a package can't depend on one listed above it.

# load

#export_pkglist <- function(){
#	installed = installed.packages(lib.loc=.libPaths()[1])[,c("Package", "Version")]
# #Sort by dependency!
#	saveRDS(installed, file="code/Rlib/pkgs.RData")
#}

update_pkgs_from_pkglist <- function(){
	load(file="code/Rlib/pkgs.RData") #loads shouldbe
	
	#uninstall the ones not needed anymore
	installed = installed.packages(lib.loc=.libPaths()[1])[,c("Package", "Version"), drop=F]
	for(i in inc_seq(1,nrow(installed))){
		pkg_name = installed[i,1]
		ind = match(pkg_name, shouldbe[,1])
		if(is.na(ind) || shouldbe[ind,2] != installed[i,2])
			remove.packages(pkg_name)
	}
	
	#install the missing ones
	installed = installed.packages(lib.loc=.libPaths()[1])[,c("Package", "Version"), drop=F]
	for(i in inc_seq(1,nrow(shouldbe))){
		pkg_name = shouldbe[i,1]
		ind = match(pkg_name, installed[,1])
		if(is.na(ind))
			InstallOldPackage(pkg_name,shouldbe[i,2])
	}
}
