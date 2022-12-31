github_url="https://github.com/ryan-heslin/Advent_of_Code_2022"
repo_name="${github_url##*/}"
echo $repo_name
subdir="solutions"
output="line_counts.csv"

git clone --depth=1 "$github_url"

# Get line counts for each solution file and format into csv
wc -l ./$repo_name/$subdir/*.* |
    sed -E 's/^\s+//' |
    sed -E 's/\s+/,/' |
    sed -E 's/\..*\///g' > $output

sed -i -e '1i"lines","file"' "$output"
rm -rf "$repo_name"
