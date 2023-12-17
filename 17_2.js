const fs = require('fs');

function findLeastHeatLoss(grid) {
  const rows = grid.length;
  const cols = grid[0].length;
  const directions = {
    'R': {x: 1, y: 0},
    'D': {x: 0, y: 1},
    'L': {x: -1, y: 0},
    'U': {x: 0, y: -1}
  };

  function isValid(node) {
    return node.x >= 0 && node.x < rows &&
      node.y >= 0 && node.y < cols &&
      node.steps <= 10;
  }

  function hash(node) {
    return `${node.x},${node.y},${node.direction},${node.steps}`;
  }

  const source1 = { x: 0, y: 0, direction: 'R', steps: 0 };
  const source2 = { x: 0, y: 0, direction: 'D', steps: 0 };
  const Q = [source1, source2];
  const dist = {[hash(source1)]: 0, [hash(source2)]: 0};
  const visited = new Set();

  while (Q.length > 0) {
    Q.sort((a, b) => dist[hash(a)] - dist[hash(b)])

    if (Q.length % 100 == 0) {
      console.log(Q.length)
    }

    const current = Q.shift();

    if (current.x === rows - 1 && current.y === cols - 1) {
      return dist[hash(current)];
    }

    if (!visited.has(hash(current))) {
      visited.add(hash(current));

      for (const [direction, delta] of Object.entries(directions)) {
        if (current.direction == 'U' && direction == 'D' ||
          current.direction == 'R' && direction == 'L' ||
          current.direction == 'D' && direction == 'U' ||
          current.direction == 'L' && direction == 'R') {
          continue;
        }

        if (current.direction !== direction && current.steps < 4) {
          continue;
        }


        const neighbour = {
          x: current.x + delta.x,
          y: current.y + delta.y,
          direction: direction,
          steps: current.direction == direction ? current.steps + 1 : 1
        }

        if (!isValid(neighbour)) {
          continue;
        }

        const heatLoss = dist[hash(current)] + parseInt(grid[neighbour.y][neighbour.x]);
        const oldDist = dist[hash(neighbour)];
        if (oldDist === undefined || heatLoss < oldDist) {
          dist[hash(neighbour)] = heatLoss
        }

        Q.push(neighbour)
      }
    }
  }

  throw Error('No path found');
}

const input = fs.readFileSync('input17', 'utf8')
  .trim()
  .split('\n')


const result = findLeastHeatLoss(input);
console.log(result);

