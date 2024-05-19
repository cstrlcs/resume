#!/bin/bash
json=$(cat resume.json)

parse_array() {
  name=$(echo "$json" | jq -r "$1 | map($2 | tojson) | .[]")
  echo $name
}

parse_prop () {
  echo "$json" | jq -r "$1"
}

bold() { echo "$(tput bold)$1$(tput sgr0)"; }
dim() { echo "$(tput dim)$1$(tput sgr0)"; }
colored() { echo "$(tput setaf 32)$1$(tput sgr0)"; }

output() {
  echo "$1" >> resume.txt
}

format_section() {
  echo "\n$(dim "###| ") $(bold $(colored $1)) $(dim " |$(printf '%*s' "$((40 - ${#1}))" | tr ' ' '=')")\n"
}

format_item () {
  echo "  $(dim "-") $1"
}

format_date() { 
  echo "$(dim [$1])"
}

> resume.txt

cat <<EOF > resume.txt
$(tput setaf 32)   __
  / /  __ _________ ____   
 / /__/ // / __/ _ \`(_-<   
/____/\_,_/\\__/\_,_/___/   
  _____         __         
 / ___/__ ____ / /________ 
/ /__/ _ \`(_-</ __/ __/ _ \\
\\___/\\_,_/___/\\__/_/  \\___/$(tput sgr0)

EOF

eval "links=($(parse_array '.basics.profiles' '.url'))"
eval "links_labels=($(parse_array '.basics.profiles' '.network'))"

eval "works=($(parse_array '.work' '.position'))"
eval "works_companies=($(parse_array '.work' '.name'))"
eval "works_dates=($(parse_array '.work' '.startDate'))"
eval "works_summaries=($(parse_array '.work' '.summary'))"

eval "skills=($(parse_array '.skills' '.keywords[]'))"

output "$(bold "$(parse_prop '.basics.name')") | $(dim "$(parse_prop '.basics.email')") | $(dim "$(parse_prop '.basics.url')")"
output "$(bold "$(parse_prop '.basics.label')")"

output "$(format_section "About")"
output "$(parse_prop '.basics.summary')"

output "$(format_section "Links")"
for i in "${!links[@]}"; do
  output "$(format_item "${links_labels[$i]} [$(dim ${links[$i]})]")"
done

output "$(format_section "Work")"
for i in "${!works[@]}"; do
  output "$(format_date ${works_dates[$i]}) | $(bold "${works[$i]}") $(bold "@") ${works_companies[$i]}"
  output "      $(dim "${works_summaries[$i]}")"
done

output "$(format_section "Skills")"
output "$(format_item "${skills[*]}")"

output "\n"
