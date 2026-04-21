# Geodesic Computation in Planar Domains

A MATLAB toolkit for computing **hyperbolic geodesics** and **quasihyperbolic geodesics** in arbitrary simply connected polygonal domains, based on the paper *"Shortest Paths in Planar Domains with Hyperbolic Type Metrics"* by Gao, Hakanen, Rasila, and Vuorinen.

---

## Overview

This toolkit implements numerical methods for computing geodesics in planar domains equipped with hyperbolic type metrics. The algorithm follows Algorithm 1 from the paper, which discretizes the domain using a uniform grid, constructs a weighted undirected graph, and solves the shortest path problem using Dijkstra's algorithm.

### Key Features

- Support for arbitrary simple polygonal domains (convex or non-convex)
- Support for multiply connected domains with holes
- Computation of quasihyperbolic geodesics
- Computation of approximate hyperbolic geodesics
- Exact hyperbolic geodesics via SC Toolbox (optional)
- Visualization of domain boundaries, grid points, and geodesics
- Bifurcation point analysis

---
| File | Description |
|------|-------------|
| `main.m` | Main entry point for general geodesic computation |
| **core/** | Core algorithm modules |
| `build_graph_edges.m` | Graph edge and weight construction |
| `check_intersect.m` | Segment-obstacle intersection test |
| `compute_single_geodesic.m` | Single geodesic computation wrapper |
| `find_bifurcation_on_real_axis.m` | Bifurcation detection on real axis |
| `find_bifurcation_point.m` | Bifurcation detection (two paths) |
| `find_shortest_path.m` | Dijkstra's shortest path algorithm |
| `generate_grid_polygon.m` | Grid generation in polygonal domains |
| `minH2.m` | Approximate hyperbolic distance in polygon |
| `polydistNew.m` | Point-to-polygon distance calculation |
| `rhoH.m` | Hyperbolic distance in upper half-plane |
| **hyperbolic/** | Hyperbolic geometry modules |
| `compute_hyperbolic_distance.m` | Exact hyperbolic distance via conformal mapping |
| `compute_hyperbolic_distance_hplmap.m` | Exact hyperbolic distance via hplmap |
| `generate_hyperbolic_geodesic.m` | General hyperbolic geodesic via conformal mapping |
| `generate_hyperbolic_geodesic_angular.m` | Exact geodesic in angular domains |
| `generate_hyperbolic_geodesic_hplmap.m` | Exact geodesic via hplmap (SC Toolbox) |
| **domain/** | Domain generation modules |
| `generate_asterisk_polygon.m` | n-asterisk polygon generation |
| `generate_point_list.m` | Symmetric point list generation |
| **visualize/** | Visualization modules |
| `plot_domain_boundary.m` | Plot domain boundary and obstacles |
| `plot_geodesic.m` | Plot geodesic path |
| `plot_grid_points.m` | Plot grid points |
| `plot_inscribed_circle.m` | Plot inscribed circle |
| `plot_points.m` | Plot point markers |
| `set_layer_order.m` | Set layer ordering in figure |
| `setup_figure.m` | Global figure settings |
| **experiments/** | Experiment scripts (paper reproduction) |
| `main_angle_domain.m` | Single geodesic in angular domain |
| `main_angle_domain_exp.m` | Bifurcation analysis in convex angular domain |
| `main_asterisk.m` | n-asterisk domain analysis (inscribed circles) |
| `main_non_convex_domain.m` | Bifurcation analysis in non-convex domain |
| **multipunctured/** | Multiply punctured domain experiments |
| `lemma_51.m` | Lemma 5.1 verification (original code) |
| `lemma_51_2.m` | Lemma 5.1 variant |
| `cal_error.m` | Error calculation for Lemma 5.1 |
| `widemarg.m` | Adjust figure width |


---

## Requirements

### MATLAB Version
- MATLAB R2020b or later

### Required Toolboxes
- MATLAB core toolbox

- **[Schwarz-Christoffel Toolbox](https://github.com/tobydriscoll/sc-toolbox)** — for exact hyperbolic geodesic computation

To install SC Toolbox:

```
matlab
% Download and extract to any directory, then add to MATLAB path
addpath('/path/to/sc-toolbox')
```

---

## QuickStart

### 1. Basic Usage

Edit the user input section in `main.m`:

```matlab
% Define polygon vertices (in order, clockwise or counterclockwise)
vertOut = [
    -4 + 1i;
    -1 + 1i;
    -1 + 4i;
     4 + 4i;
     4 - 4i;
    -1 - 4i;
    -1 - 1i;
    -4 - 1i
];

% Define two target points (must be inside the polygon)
P1 = -2 + 0i;
P2 =  2 + 2i;

% Algorithm parameters
h = 0.02;       % Grid step size
m = 6;          % Neighborhood parameter

```

### 2. Run

```matlab
>> main
```

### 3. Sample Output
=== Hyperbolic and Quasihyperbolic Geodesic Computation ===

Domain: polygon with 8 vertices
Points: P1 = -2.000 + 0.000i, P2 = 2.000 + 2.000i
Parameters: h = 0.0200, m = 6

Step 1: Generating grid...
  Generated 4523 grid points
Step 2: Building weighted graph...
  QH graph: 12345 edges
  Hyp graph: 11892 edges
Step 3: Computing shortest paths...
  QH geodesic length: 8.23456
  Hyp geodesic length (approx): 6.12345
Step 4: Computing exact hyperbolic geodesic...
  Exact Hyp geodesic length: 6.09876
Step 5: Visualizing results...

=== Results Summary ===
Quasihyperbolic length:     8.23456
Hyperbolic length (approx): 6.12345
Hyperbolic length (exact):  6.09876
Approximation error:        0.02469

Ratio k_G / rho_G: 1.3504
Theoretical bounds: 1 <= k_G/rho_G <= 2 (for simply connected domains)

## Expected Visualization

The program generates a figure showing:

- **Black solid line**: Domain boundary
- **Green solid line**: Exact hyperbolic geodesic (if SC Toolbox available)
- **Magenta dashed line**: Approximate hyperbolic geodesic
- **Blue dotted line**: Quasihyperbolic geodesic
- **Black circle**: Start point P1
- **Black square**: End point P2
- **Cyan dots**: Grid points (if `show_grid = true`)

## Parameter Description

| Parameter | Description | Recommended Value |
|-----------|-------------|-------------------|
| `h` | Grid step size. Controls discretization accuracy. Smaller values increase precision but computational cost grows as O(1/h^2). | 0.01 ~ 0.05 |
| `m` | Neighborhood parameter (`dir` in the paper). Controls the number of neighbors per grid point. Neighbor distance range: `[m*h, sqrt(2)*m*h]`. | 4 ~ 8 |
| `show_grid` | Whether to display grid points. | `false` |
| `show_exact` | Whether to compute and display exact hyperbolic geodesic (requires SC Toolbox). | `true` |
| `save_figure` | Whether to save the figure to a file. | `false` |
| `output_filename` | Filename for saved figure. | `'geodesic_result.png'` |

## Custom Domain Examples

### Example 1: Rectangular Domain

```matlab
vertOut = [0+0i; 5+0i; 5+3i; 0+3i];
P1 = 1 + 1i;
P2 = 4 + 2i;
```

### Example 2: L-shaped Domain
```matlab
vertOut = [0+0i; 3+0i; 3+1i; 1+1i; 1+3i; 0+3i];
P1 = 0.5 + 0.5i;
P2 = 2.5 + 2.5i;
```

### Example 3: Polygon Domain
```matlab
theta = linspace(0, 2*pi, 11)';
r = 2 + 0.8*sin(5*theta(1:end-1));
vertOut = r .* exp(1i*theta(1:end-1));
P1 = 0 + 0i;
P2 = 1 + 0.5i;
```

### Example 4: Triangle Domain
```matlab
vertOut = [0+0i; 4+0i; 2+3i];
P1 = 1 + 0.5i;
P2 = 3 + 1i;
```
### Example 5: Regular Pentagon
```matlab
n = 5;
theta = linspace(0, 2*pi, n+1)';
vertOut = 3 * exp(1i*theta(1:end-1));
P1 = 0 + 0i;
P2 = 1.5 + 0.5i;

```

## Experiment Scripts

| Script | Paper Section | Description |
|--------|---------------|-------------|
| `main_angle_domain.m` | 5.4 | Single geodesic in angular domain |
| `main_angle_domain_exp.m` | 5.4 | Geodesic bifurcation in convex domain |
| `main_asterisk.m` | 7 | Inscribed circle comparison in n-asterisk domain |
| `multipunctured` | 5.3 | Non-uniqueness of geodesics in multiply connected domain |
| `main_non_convex_domain.m` | 5.5 | Bifurcation analysis in non-convex domain |

## FAQ

### Q1: Error "P1 is not inside the polygon"

**A:** Verify that the point coordinates are indeed inside the polygon. Ensure vertices are listed in order.

```matlab
% Check if point is inside
[in, ~] = inpolygon(real(P1), imag(P1), real(vertOut), imag(vertOut));
disp(in);  % Should return 1
```

### Q2: Geodesic appears jagged or crosses boundaries
**A:** Decrease h or increase m to improve grid resolution.
```matlab
h = 0.005;   % Finer grid
m = 8;       % More neighbors
```

### Q3: Computation takes too long
**A:** Increase h or reduce the grid region.
```matlab
h = 0.05;    % Coarser grid
margin = 0.2; % Smaller margin around points
```

### Q4: Functions in SC Toolbox is not available
**A:** If you use hplmap, it will works, but if you use diskmap, sometimes it may fails.

### Q5: Incorrect geodesic in non-convex domain
**A:** Ensure check_intersect.m is working properly and the obstacle list is correctly passed.
```matlab
% Debug: test intersection check
ps = -2 + 0i;
pt = 2 + 2i;
result = check_intersect(ps, pt, obs_list);
disp(result);  % Should be 0 if no intersection
```

## Remark
- The whole program is summarized from the experiment codes. We use Deepseek to summarize, translate.
- For domain with boundary, currently it works on simply connected domain. Actually it also works on multi-punctured domain, but it is hard to program. We gonna add more codes later.
- Sometimes it will take a bit more time, depending on how many points in mesh.
- Notice that in non-simply connected domain, the hyperbolic geodesic is not defined.