#!/usr/bin/env bb

(ns html2hiccup
  (:require [babashka.pods :as pods]
            [babashka.deps :as deps]
            [clojure.string :as str]))

(pods/load-pod 'retrogradeorbit/bootleg "0.1.9")
(deps/add-deps '{:deps {zprint/zprint {:mvn/version "1.2.4"}}})
(deps/add-deps '{:deps {org.babashka/spec.alpha {:git/url "https://github.com/babashka/spec.alpha"
                                                 :git/sha "1a841c4cc1d4f6dab7505a98ed2d532dd9d56b78"}}})

(require '[pod.retrogradeorbit.bootleg.utils :refer [convert-to]]
         '[zprint.core :refer [zprint]])

(-> *in*
    slurp
    (str/replace #"((?<=>)\s+|\s+(?=<))" "")
    (convert-to :hiccup-seq)
    (->> (run! #(zprint % {:style :hiccup :map {:comma? false :force-nl? true} :width 4096}))))
