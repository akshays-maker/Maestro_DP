# Maestro Automation Setup

## How to Run Maestro Flows

1. Ensure Maestro CLI is installed. If not, run:
   ```sh
   curl -Ls https://get.maestro.mobile.dev | bash
   export PATH="$PATH":"$HOME/.maestro/bin"
   ```
2. Place your flow YAML files in this directory.
3. To run a flow, use:
   ```sh
   maestro test <your-flow-file.yaml>
   ```

## Example

To run the sample flow:
```sh
maestro test sample_flow.yaml
```
