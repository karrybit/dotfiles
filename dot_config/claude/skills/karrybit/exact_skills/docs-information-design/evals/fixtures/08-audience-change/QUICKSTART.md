# inventory-api: deploy to staging

Prereqs: kubectl ctx `staging`, ns `inventory`, `inventory-db` secret present.

```
kubectl config use-context staging
kubectl -n inventory get secret inventory-db
kubectl apply -f deploy/app.yaml
kubectl -n inventory rollout status deploy/inventory-api
kubectl -n inventory port-forward deploy/inventory-api 8080:8080
curl localhost:8080/healthz
```

Not ready → `kubectl -n inventory describe pod -l app=inventory-api`; usually the secret.

Rollback: `kubectl -n inventory rollout undo deploy/inventory-api`.
