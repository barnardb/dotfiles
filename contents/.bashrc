for file in ~/.interactive-shells.d/*.sh; do
    . "${file}"
done

for file in ~/.bashrc.d/*.sh; do
    . "${file}"
done
