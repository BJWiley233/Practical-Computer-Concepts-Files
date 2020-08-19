setClass(
    Class = "PartitionFather",
    representation = representation(nbGroups="numeric", "VIRTUAL")
)

setGeneric("nbMultTwo", function(object){standardGeneric("nbMultTwo")})

setMethod(f="nbMultTwo", signature="PartitionFather",
          definition = function(object){
              object@nbGroups <- object@nbGroups*2
              return(object)
          }
)

# ----Subclasses, message=FALSE----------------------------------------------------
setClass(
    Class = "PartitionSimple",
    representation = representation(part = "factor"),
    contains = "PartitionFather"
)

setClass(
    Class = "PartitionEval",
    representation = representation(part = "ordered"),
    contains = "PartitionFather"
)

getClass("PartitionFather")
getClass("PartitionSimple")
getClass("GeneFeatureSet")

a <- new("PartitionSimple", nbGroups=3, part=factor(LETTERS[c(1,2,3,2,2,1)]))
nbMultTwo(a)

b <- new("PartitionEval", nbGroups=3, part=ordered(LETTERS[c(1,2,3,2,2,1)]))
nbMultTwo(b)


new("GeneFeatureSet")
new("FeatureSet")
# Objects for FeatureSet-like classes can be created by calls of the form: new(CLASSNAME, assayData, manufacturer, platform, exprs, phenoData, featureData, experimentData, annotation, ...). But the preferred way is using parsers like read.celfiles and read.xysfiles.
?GeneFeatureSet()
