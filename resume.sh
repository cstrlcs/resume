#/bin/bash

eval $(curl -s https://raw.githubusercontent.com/cstrlcs/resume/main/resume.conf)

bold() { echo "$(tput bold)$1$(tput sgr0)"; }
dim() { echo "$(tput dim)$1$(tput sgr0)"; }
colored() { echo "$(tput setaf 60)$1$(tput sgr0)"; }

output_ascii() {
  echo "$(tput setaf 60) $(tput bold)"
  cat << "EOF"
   __                      
  / /  __ _________ ____   
 / /__/ // / __/ _ `(_-<   
/____/\_,_/\__/\_,_/___/   
  _____         __         
 / ___/__ ____ / /________ 
/ /__/ _ `(_-</ __/ __/ _ \
\___/\_,_/___/\__/_/  \___/
                           
EOF

echo $(tput sgr0)
}

output_date() { 
  echo "$(dim [$1])"
}

output_section() {
  echo
  echo "$(dim "###| ") $(bold $(colored $1)) $(dim " |$(printf '%*s' "$((40 - ${#1}))" | tr ' ' '=')")"
  echo
}

output_item () {
  echo "  $(dim "-") $1"
}

output_ascii
echo "$(bold "$name") | $(dim "$email") | $(dim "$url")"
echo "$(bold "$label")"

output_section "About"

echo "$summary"

output_section "Links"

for i in "${!links[@]}"
do
  output_item "${links_labels[$i]} [$(dim ${links[$i]})]"
done

output_section "Work"

for i in "${!works[@]}"
do
  output_item "$(output_date ${works_dates[$i]}) | $(bold "${works[$i]}") $(bold "@") ${works_companies[$i]}"
  echo "      $(dim "${works_summaries[$i]}")"
done

output_section "Skills"
output_item "${skills[*]}"

#printf '\n\e]8;;https://resume.lucascastro.dev/\e\\Click here see my full CV 🚀\e]8;;\e\\\n\n'
