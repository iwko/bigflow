# bigflow-build-tools

## Usage

An example of using actions in a workflow:

### ci

```yaml
...
steps:
  - uses: allegro-actions/bigflow/setup@master
    with:
      release_sshkey: '<SSH_KEY>'
...
```
