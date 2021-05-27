from graphviz import Digraph, Graph
dot = Digraph(comment='The Round Table')
dot.node('A', 'King Arthur')
dot.node('B', 'Sir Bedevere the Wise')
dot.node('L', 'Sir Lancelot the Brave')
dot.node('G', 'Garfunkle')
dot.edges(['AB', 'AL', 'GL'])
dot.edge('B', 'L', constraint='false')
dot.render('../testOutputs/graphvizTest.svg')
