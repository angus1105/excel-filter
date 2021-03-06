#!/bin/sh

openssl aes-256-cbc -k "$travis_key_password" -d -md sha256 -a -in travis_key.enc -out travis_key
echo "Host github.com" > ~/.ssh/config
echo "  IdentityFile  $(pwd)/travis_key" >> ~/.ssh/config
chmod 400 travis_key
git remote set-url origin git@github.com:angus1105/excel-filter.git
echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFbeGdW09kEVy60n4cRjPiDn/KMKtQvIyRDDs14e2YhplzStHo09lQPggwOkBjg3benQwzLnf2LjBahlOZURA69ulHRrfMz995+BINzh5HDunyNocu5rdKYYRDn2thkZCF8r23QrkGdjXgo/VUyDT6dCjlMZwYL/tmt6G64HmaY6UhBgt6mMLzXgfsHP3TKEhiejOo0FW2qD4ukiinOQttjOQMDMSFMq4LC7ne7cNOFtsZcqOTNG5fyPosOs78AHmSreblA7+KIWks+f1Aan0mOmh+H9VcC8AtfQ51o2fdWD2ZeziQknWMtVYB6Jnr81s7rJA1PUnlzDkZI+lsWJaceKo4zc9gu7vAa+iPJYeLdHfivF1IvdT0PIR6Y4DmS5QFxHXnhkHI6Iit7GMMds79A3lfgzu/SCbQmG7yciu2EsqSEY1Bjs74LUB+rSJu/j5D56WyaSkJme1+cb4s+mGQ0GEn9zilMl+nCyWpMdoSAigahYeohA91wC2Y3Mr5PyOcwthnMrLOqU0QVXsnsGyD7otDiIxA5w58Wae+OkJ2f+6ZGDfP1UeXENwBC+dhn2nqIWgUxi4d5ERIUvPAUHFffsdbztvRzs0YXuC3IJN0VrtpToIURtg/qv3GQI6+Qc8yeQ+/HaDR0gzvqS4VFoCAV+U8NaD+1GpgXoI1Pb4UYQ==" > ~/.ssh/known_hosts 
if ! git push -v ; then
  _err "git push error"
fi