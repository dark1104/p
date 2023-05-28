#include <iostream>
#include <queue>
#include <vector>

// Undirected graph representation using adjacency list
class Graph {
    int V;                        // Number of vertices
    std::vector<std::vector<int>> adj;   // Adjacency list

public:
    Graph(int V) : V(V), adj(V) {}

    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }

    // Parallel Breadth First Search
    void parallelBFS(int start) {
        std::vector<bool> visited(V, false);
        std::queue<int> q;
        visited[start] = true;
        q.push(start);

        #pragma omp parallel
        {
            while (!q.empty()) {
                int curr;

                #pragma omp critical
                {
                    curr = q.front();
                    q.pop();
                }

                #pragma omp for
                for (size_t i = 0; i < adj[curr].size(); ++i) {
                    int next = adj[curr][i];
                    if (!visited[next]) {
                        visited[next] = true;
                        #pragma omp critical
                        {
                            q.push(next);
                        }
                    }
                }
            }
        }

        std::cout << "Parallel BFS from vertex " << start << ":\n";
        for (int i = 0; i < V; ++i) {
            if (visited[i]) {
                std::cout << i << " ";
            }
        }
        std::cout << std::endl;
    }

    // Parallel Depth First Search
    void parallelDFS(int start) {
        std::vector<bool> visited(V, false);
        #pragma omp parallel
        {
            #pragma omp single
            {
                visited[start] = true;
                std::cout << "Parallel DFS from vertex " << start << ":\n";
                std::cout << start << " ";
            }

            #pragma omp single
            {
                parallelDFSUtil(start, visited);
            }
        }
    }

    // Depth First Search Utility function
    void parallelDFSUtil(int v, std::vector<bool>& visited) {
        #pragma omp for
        for (size_t i = 0; i < adj[v].size(); ++i) {
            int next = adj[v][i];
            if (!visited[next]) {
                #pragma omp critical
                {
                    visited[next] = true;
                    std::cout << next << " ";
                }
                parallelDFSUtil(next, visited);
            }
        }
    }
};

int main() {
    int V = 8; // Number of vertices
    Graph graph(V);

    // Adding edges to the graph
    graph.addEdge(0, 1);
    graph.addEdge(0, 2);
    graph.addEdge(1, 3);
    graph.addEdge(1, 4);
    graph.addEdge(2, 5);
    graph.addEdge(2, 6);
    graph.addEdge(3, 7);

    // Perform parallel BFS and DFS
    graph.parallelBFS(0);
    std::cout << std::endl;
    graph.parallelDFS(0);
    std::cout << std::endl;

    return 0;
}
