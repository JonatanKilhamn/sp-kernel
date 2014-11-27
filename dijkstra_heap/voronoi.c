/*
 * voronoi.c.  C code to create the voronoi graph using a modified
 * Dijkstra's algorithm. Uses a min-heap as the priority queue.
 *
 *
 * The calling syntax is:
 *
 *		[grouping, vorAdj] = voronoi(adj, size, vorNodes)
 *
 *
 * Input:
 *  adj - 3-row matrix; representation of a sparse adjacency matrix;
 *    transpose of the "natural" 3-column representation
 *  size - integer; number of nodes
 *  vorNodes - integer vector containing the indices of the nodes
 *    chosen to be voronoi nodes
 *
 * Output:
 *  grouping: vector of length [size], assigning each node in the original
 *    graph to one of the voronoi nodes
 *  vorAdj: the voronoi adjacency matrix, i.e. the distances between the
 *    connected voronoi nodes
 *
 * Preconditions:
 *  - the graph must be connected, or rather, every node
 *    must have at least one edge.
 *  - all edges must have positive, non-zero weights
 *
 * This is a MEX-file for MATLAB.
*/




#include <stdio.h>
#include "mex.h"
#include "matrix.h"




/* Return the index of the parent of node i. */
int parent(int i) {
  return i / 2;
}

/* Return the index of the left child of node i. */
int left(int i) {
  return 2 * i;
}

/* Return the index of the right child of node i. */
int right(int i) {
  return 2 * i + 1;
}

/* Exchange nodes i and j, updating their keys, handles, and
   heap_index values. */
void exchange(double key[], int handle[], int heap_index[], int i, int j) {
  double key_temp;
  int handle_temp;

  /* Exchange the keys in nodes i and j. */
  key_temp = key[i];
  key[i] = key[j];
  key[j] = key_temp;

  /* Exchange the handles in nodes i and j. */
  handle_temp = handle[i];
  handle[i] = handle[j];
  handle[j] = handle_temp;

  /* Update the heap_index values. */
  heap_index[handle[i]] = i;
  heap_index[handle[j]] = j;
}

/* Make the min-heap rooted at node i obey the min-heap property.
   Assumes that the subtrees rooted at i's left and right children
   already obey the min-heap property. */
void heapify(double key[], int handle[], int heap_index[], int i, int size) {
  int l = left(i);
  int r = right(i);
  int smallest;

  /* Is the left child smaller than node i? */
  if (l <= size && key[l] < key[i])
    smallest = l;
  else
    smallest = i;

  /* Is the right child smaller than node i and i's left child? */
  if (r <= size && key[r] < key[smallest])
    smallest = r;

  /* If the min-heap property is violated between node i and one of
     its children, fix it. */
  if (smallest != i) {
    exchange(key, handle, heap_index, i, smallest);
    heapify(key, handle, heap_index, smallest, size);
  }
}

/* Take an array that does not necessarily obey the min-heap property,
   and rearrange it so that it does. */
void build_heap(double key[], int handle[], int heap_index[], int size) {
  int i;
  for (i = size/2; i >= 1; --i)
    heapify(key, handle, heap_index, i, size);
}

/* Extract the node with the minimum key, at index 1, from the
   min-heap. */
void extract_min(double key[], int handle[], int heap_index[], int size) {
  exchange(key, handle, heap_index, 1, size);
  heapify(key, handle, heap_index, 1, size-1);
}

/* Bubble the key in node i up toward the root until the min-heap
   property is restored. */
void decrease_key(double key[], int handle[], int heap_index[],
		  int i, int size, double new_key) {
  key[i] = new_key;
  while (i > 1 && key[parent(i)] > key[i]) {
    exchange(key, handle, heap_index, i, parent(i));
    i = parent(i);
  }
}

/* Insert a new node into the min-heap.  Assumes that an array element
   has already been allocated. */
void insert(double key[], int handle[], int heap_index[], 
	    int vertex, int size, double new_key) {
  key[++size] = 1000000000.0;	/* will be fixed later */
  handle[size] = vertex;
  heap_index[vertex] = size;
  decrease_key(key, handle, heap_index, size, size, new_key); /* here's later */
}

/* Relax edge (u, v) with weight w. */
void relax(int u, int v, double w, double key[], int handle[], int heap_index[], int size, int pi[], double dist[], double grouping[]) {
  if (key[heap_index[v]] > key[heap_index[u]] + w) {
    decrease_key(key, handle, heap_index, heap_index[v], size, key[heap_index[u]] + w);
    pi[v] = u;
    dist[v] = dist[u] + w;
    grouping[v] = grouping[u];
  }
}

/* Initialize a multi-source shortest-paths computation. */
void initialize_multi_source(double key[], int handle[], int heap_index[],
			      int pi[], double dist[], double grouping[], int vor[], int n, int nVor) {
  int i;
  for (i = 1; i <= n; ++i) {
    key[i] = 1000000000.0;
    dist[i] = 1000000000.0;
    handle[i] = i;
    heap_index[i] = i;
    pi[i] = 0;
  }

  for (i = 1; i <= nVor; ++i) {
    key[vor[i]] = 0.0;
    dist[vor[i]] = 0.0;
    grouping[vor[i]] = (double) i; /*vor[i];*/
  }
  
  build_heap(key, handle, heap_index, n);
}

/* Run Voronoi-Dijkstra from voronoi vertices vor.  Fills in arrays d and pi. */
void vor_dijkstra(int first[], int node[], int next[], double w[], double d[],
	      int pi[], double dist[], double grouping[], int vor[], int n, int nVor, int handle[], int heap_index[]) {
  int size = n;
  int u, v, i;

  initialize_multi_source(d, handle, heap_index, pi, dist, grouping, vor, n, nVor);
  while (size > 0) {
    u = handle[1];
    extract_min(d, handle, heap_index, size);
    --size;
    i = first[u];
    while (i > 0) {
      v = node[i];
      relax(u, v, w[i], d, handle, heap_index, size, pi, dist, grouping);
      i = next[i];
    }
  }
}


/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{


if(nrhs!=3) {
    mexErrMsgIdAndTxt("MyToolbox:dijkstra_matlab:nrhs",
                      "Three inputs required.");
}
if(nlhs!=2) {
    mexErrMsgIdAndTxt("MyToolbox:dijkstra_matlab:nlhs",
                      "Two outputs required.");
}


/* make sure the first argument (adj) is a 3-row matrix */
if( !mxIsDouble(prhs[0]) || 
     mxIsComplex(prhs[0])) {
    mexErrMsgIdAndTxt("MyToolbox:dijkstra_matlab:notDouble",
        "Input matrix 'adj' must be type double.");
}
if ( mxGetM(prhs[0]) != 3) {
    mexErrMsgIdAndTxt("MyToolbox:dijkstra_matlab:wrongNbrRows",
        "Input matrix must have three rows.");
}
/* make sure the second argument (size) is scalar */
if( !mxIsDouble(prhs[1]) || 
     mxIsComplex(prhs[1]) ||
     mxGetNumberOfElements(prhs[1])!=1 ) {
    mexErrMsgIdAndTxt("MyToolbox:dijkstra_matlab:notScalar",
                      "Input size must be a scalar.");
}
/* make sure the third argument (vorNodes) is a nonempty matrix */
if( !mxIsDouble(prhs[2]) || 
     mxIsComplex(prhs[2])  ||
     mxGetNumberOfElements(prhs[2]) == 0 ) {
    mexErrMsgIdAndTxt("MyToolbox:dijkstra_matlab:notDouble",
        "Input matrix 'voronoi_nodes' must be type double.");
}



/* Get the 'size' input */
int size;
size = mxGetScalar(prhs[1]);


/* Get the input matrices */
int nEdges = mxGetN(prhs[0]);
mxArray *adjArray = mxDuplicateArray(prhs[0]);
double *adj = mxGetPr(adjArray);

int nVorNodes = mxGetN(prhs[2]);
int vorNodes[nVorNodes+1];

mxArray *vorNodesArray = mxDuplicateArray(prhs[2]);
double *vorNodesDouble = mxGetPr(vorNodesArray);

int i;
for (i = 0; i < nVorNodes; i++) {
  vorNodes[i+1] = (int) vorNodesDouble[i];
}


/* output */
plhs[0] = mxCreateDoubleMatrix(size, 1, mxREAL);
plhs[1] = mxCreateDoubleMatrix(nVorNodes, nVorNodes, mxREAL);

/*double *grouping = mxGetPr(plhs[0]);*/
double *vorAdj = mxGetPr(plhs[1]);




int first[size+1], node[nEdges+1], next[nEdges+1], pi[size+1], handle[size+1], heap_index[size+1];
double w[nEdges+1], d[size+1], grouping[size+1], dist[size+1];

int row, rowIndex, current, from, to, weight, previousFrom;

/* Special cases for first edge */
current = 1;
first[1] = 1;
node[1] = adj[1]; /* row 1, col 2 (i.e. row 0, col 1) */
w[1] = adj[2];



for (row = 2; row <= nEdges; row++) {
  rowIndex = row-1;
  from = adj[rowIndex*3];
  to = adj[rowIndex*3 + 1];
  weight = adj[rowIndex*3 + 2];  
  previousFrom = adj[(rowIndex-1)*3];
  if (from != previousFrom) {
    /* We have moved on to a new node */
    first[from] = row;
    next[row-1] = 0;
    current++;
  } else {
    /* we have another edge from the same node */
    next[row-1] = row;
  }
  
  /* We note the destination and weight in either case*/
  w[row] = weight;
  node[row] = to;
}

/* Special case for last edge */

next[nEdges] = 0;


/* Call dijkstra */
vor_dijkstra(first, node, next, w, d, pi, dist, grouping, vorNodes, size, nVorNodes, handle, heap_index);

/* We now have the correct values in 'grouping'. Now to find the lengths:*/

for (i = 0; i < (nVorNodes*nVorNodes); i++) {
   vorAdj[i] = 1000000000.0;
}

double *out1 = mxGetPr(plhs[0]);
for (i = 1; i <= size; i++) {
  out1[i-1] = grouping[i];
}


double distance;
int fromVor, toVor, matIndex, matInvIndex;

for (row = 1; row <= nEdges; row++) {
  rowIndex = row-1;
  from = adj[rowIndex*3];
  to = adj[rowIndex*3 + 1];
  weight = adj[rowIndex*3 + 2];
  fromVor = (int) grouping[from];
  toVor = (int) grouping[to];
  if (fromVor != toVor) {
    distance = dist[from] + dist[to] + weight;
    matIndex = (nVorNodes * (fromVor - 1)) + toVor - 1;
    matInvIndex = (nVorNodes * (toVor - 1)) + fromVor - 1;
    if (distance < vorAdj[matIndex]) {
      vorAdj[matIndex] = distance;
      vorAdj[matInvIndex] = distance;
    }
  }
}


mxDestroyArray(adjArray);
mxDestroyArray(vorNodesArray);

}




