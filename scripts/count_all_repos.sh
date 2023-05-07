#!/usr/bin/bash
#TODO handle repeat column names

last_AoC_year(){

current_year="$(date +'%Y')"
current_month="$(date +'%m')"
current_day="$(date +'%d')"
christmas_eve=24

if [ "$current_month" -eq 12 ]  && [ "$current_day" -gt "$christmas_eve" ]; then
    latest_year=current_year
else
    latest_year=$((current_year -1))
fi
echo "$latest_year"
}

all_AoC_years(){
    first_AoC_year=2015
    end=$(last_AoC_year)
    echo "$(seq "$first_AoC_year" "$end")"
}

output="$1"

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "$script_dir"
#https://www.baeldung.com/linux/reading-output-into-array
IFS=$'\n'
read -r -d '' -a years < <( all_AoC_years && printf '\0' )
IFS=' '
url_stem='https://github.com/ryan-heslin/Advent_of_Code_'

[ ! -f "$output" ] && touch "$output"

for year in "${years[@]}"; do
    echo "$year"
    "$script_dir"/count_repo_lines.sh -y "$year" -u "${url_stem}${year}" -p 'day*.*' >> "$output"
done
sed -i -e '1i"year","lines","file"' "$output"
