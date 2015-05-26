#!/bin/sh
# @Author: GC-Mac
# @Date:   2015-05-26 13:51:13
# @Last Modified by:   GC-Mac
# @Last Modified time: 2015-05-26 13:52:43

rails d model prediction time:datetime longitude:float latitude:float station:references temperature:references railfallPrediction:references windSpeed:references windDirection:references
rails g model prediction time:datetime longitude:float latitude:float station:references temperature:references railfallPrediction:references windSpeed:references windDirection:references
