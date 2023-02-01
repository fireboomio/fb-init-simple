case $1 in
  (install)
    cd custom-ts
    npm install
    cd ../
    ;;
  (dev)
    cd custom-ts
    npm run dev
    ;;
  (start)
    cd custom-ts
    npm run start
esac