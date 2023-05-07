#!/usr/bin/bash

#TODO:
# 1. Args for year, output
# 2. Add year to CSV
# 3. Wrap in for loop
# 4. Plot LoC for all 8 years
pattern='*.*'
while [ "$#" -gt 0 ]; do
    key="$1"
    case "$key" in
        -u|--url)
            github_url="$2"
            shift
            shift
            ;;
        -y|--year)
            year="$2"
            shift
            shift
            ;;
        -p|--pattern)
            pattern="$2"
            shift
            shift
            ;;
        *) echo "Invalid flag $2"
           exit
    ;; esac
done




#github_url="https://github.com/ryan-heslin/Advent_of_Code_2022"
repo_name="${github_url##*/}"
#echo "${github_url}"
subdir="solutions"
#output="line_counts.csv"

# From https://github.com/pcoltau/git-clone-repo-to-temp-dir/blob/master/git-clone-repo.sh
temp_dir="$(mktemp -d)" && \
    git clone -q --depth=1 "$github_url" "$temp_dir"

to_remove="$(echo "${temp_dir%.*}" |  sed 's/\//\\\//g')"
# Get line counts for each solution file and format into csv
glob="${temp_dir}/${subdir}/$pattern"
wc -l $glob | # Leave unquoted to ensure this globs
    sed -E "s/^\s*/${year},/" | #Add year column to output
    sed -E 's/\s+/,/' |
    sed -E 's/\..*\///g' |
    sed -E "s/${to_remove}//"

# Add headers
#sed -i -e '1i"year","lines","file"' "${output}"
