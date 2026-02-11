if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <remote_dir>"
    exit 1
fi

file="$1"
remote_dir="$2"

HOSTS=(
    "exachem2"
    "memu"
    "rafi"
    "rafi2"
    "rafi3"
    "rafi4"
    "rafi5"
)

for host in "${HOSTS[@]}"; do
    set -x
    scp "$file" "$host:$remote_dir"
    set +x
done