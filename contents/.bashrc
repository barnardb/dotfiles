for file in ~/.{interactive-shells,bashrc}.d/*.sh; do
    . "${file}"
done
