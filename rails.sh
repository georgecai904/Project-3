#!/bin/sh
# @Author: GC-Mac
# @Date:   2015-05-26 13:51:13
# @Last Modified by:   GC-Mac
# @Last Modified time: 2015-05-26 14:03:57

rails d model railfallPrediction probability:float value:float regression:references
rails g model rainfallPrediction probability:float value:float regression:references