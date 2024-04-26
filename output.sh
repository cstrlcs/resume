#!/bin/bash

json=$(cat resume.json)

parse_array() {
  name=$(echo "$json" | jq -r "$1 | map($2 | tojson) | .[]")
  echo $name
}

parse_prop () {
  echo "$json" | jq -r "$1"
}

> resume.conf


echo "name=\"$(parse_prop '.basics.name')\"" >> resume.conf
echo "email=\"$(parse_prop '.basics.email')\"" >> resume.conf
echo "url=\"$(parse_prop '.basics.url')\"" >> resume.conf
echo "label=\"$(parse_prop '.basics.label')\"" >> resume.conf
echo "summary=\"$(parse_prop '.basics.summary')\"" >> resume.conf

echo "links=($(parse_array '.basics.profiles' '.url'))" >> resume.conf
echo "links_labels=($(parse_array '.basics.profiles' '.network'))" >> resume.conf

echo "works=($(parse_array '.work' '.position'))" >> resume.conf
echo "works_companies=($(parse_array '.work' '.name'))" >> resume.conf
echo "works_dates=($(parse_array '.work' '.startDate'))" >> resume.conf
echo "works_summaries=($(parse_array '.work' '.summary'))" >> resume.conf

echo "skills=($(parse_array '.skills' '.keywords[]'))" >> resume.conf

