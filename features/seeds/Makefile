INPUT=$(shell find /scratch_net/miro/boxavier/data/BSD500/data/images/test/ -name "*.jpg")
OUTPUT=$(INPUT:.jpg=.png)


%.png  : %.jpg
	./bin/seeds $< 200

all: $(OUTPUT)





