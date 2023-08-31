main.pdf: media/deps_graph.pdf main.tex media/*
	latexmk -pdf main.tex

media/deps_graph.pdf: media/deps_graph.dot
	dot -Tpdf media/deps_graph.dot > media/deps_graph.pdf

