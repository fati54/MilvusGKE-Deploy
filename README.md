# MilvusGKE-Deploy

Ce projet permet de déployer Milvus sur Google Kubernetes Engine (GKE) avec différentes configurations pour s'adapter à vos besoins et votre budget.

## Prérequis

- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)
- Un projet Google Cloud actif avec la facturation activée

## Configurations disponibles

1. **Eco** : Configuration économique pour le développement ou les tests.
2. **Standard** : Configuration équilibrée pour la production à petite échelle.
3. **High-Perf** : Configuration haute performance pour les charges de travail intensives.

## Utilisation

1. Clonez ce dépôt :
   ```
   git clone https://github.com/votre-username/MilvusGKE-Deploy.git
   cd MilvusGKE-Deploy
   ```

2. Choisissez une configuration en copiant le fichier .env correspondant :
   ```
   cp configs/eco.env .env  # ou standard.env ou high-perf.env
   ```

3. Modifiez le fichier .env selon vos besoins, notamment le PROJECT_ID.

4. Rendez les scripts exécutables :
   ```
   chmod +x scripts/*.sh
   ```

5. Créez le cluster GKE :
   ```
   ./scripts/create_cluster.sh
   ```

6. Déployez Milvus :
   ```
   ./scripts/deploy_milvus.sh
   ```

7. Pour mettre à jour Milvus :
   ```
   ./scripts/update_milvus.sh
   ```

8. Pour nettoyer les ressources :
   ```
   ./scripts/cleanup.sh
   ```

## Personnalisation

- Vous pouvez ajuster les valeurs dans les fichiers .env pour personnaliser votre déploiement.
- Les fichiers de configuration Milvus se trouvent dans le dossier `milvus-values/`. Vous pouvez les modifier pour ajuster les paramètres de Milvus.

## Coûts

- La configuration **Eco** est la moins chère, adaptée pour le développement et les tests.
- La configuration **Standard** offre un bon équilibre entre coût et performance pour la production à petite échelle.
- La configuration **High-Perf** est la plus coûteuse mais offre les meilleures performances pour les charges de travail intensives.

Assurez-vous de surveiller vos coûts GCP régulièrement.

## Dépannage

Si vous rencontrez des problèmes :
1. Vérifiez les logs des pods : `kubectl logs -f [POD_NAME] -n milvus`
2. Vérifiez l'état des pods : `kubectl get pods -n milvus`
3. Vérifiez les services : `kubectl get services -n milvus`

## Contribuer

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou une pull request.

## Licence

Ce projet est sous licence MIT.
