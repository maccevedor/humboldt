from django.db import migrations, transaction


def forwards_func(apps, schema_editor):
    Project = apps.get_model('projects', 'Project')
    LayerGroup = apps.get_model('projects', 'LayerGroup')
    Layer = apps.get_model('projects', 'Layer')

    try:
        project = Project.objects.get(nombre_corto='general')
    except Project.DoesNotExist:
        # Nothing to do if general project isn't present
        return

    with transaction.atomic():
        group, _ = LayerGroup.objects.get_or_create(
            proyecto=project,
            nombre='Restauración',
            defaults={'orden': 7, 'fold_state': 'close'}
        )

        # Desired layer definitions and correct workspaces (as per production)
        desired = [
            # nombre_geoserver, nombre_display, store_geoserver, metadata_id, orden
            ('integr_total4326', 'Integridad', 'restauracion', '55d29ef5-e419-489f-a450-3299e4bcc4d4', 1),
            ('red_viveros', 'Red Viveros', 'visor', None, 2),
            ('scen_mincost_target1', 'Escenario mínimo costo target 1', 'weplan', '1d6b06b6-8a57-4c87-97ef-e156cb40dc46', 3),
            ('scen_mincost_target2', 'Escenario mínimo costo target 2', 'weplan', '1d6b06b6-8a57-4c87-97ef-e156cb40dc46', 4),
            ('scen_mincost_target3', 'Escenario mínimo costo target 3', 'weplan', '1d6b06b6-8a57-4c87-97ef-e156cb40dc46', 5),
            ('scen_mincost_target4', 'Escenario mínimo costo target 4', 'weplan', '1d6b06b6-8a57-4c87-97ef-e156cb40dc46', 6),
        ]

        for nombre_geoserver, nombre_display, store, metadata_id, orden in desired:
            layer, created = Layer.objects.get_or_create(
                grupo=group,
                nombre_geoserver=nombre_geoserver,
                defaults={
                    'nombre_display': nombre_display,
                    'store_geoserver': store,
                    'estado_inicial': False,
                    'metadata_id': metadata_id,
                    'orden': orden,
                },
            )
            if not created:
                # Ensure display name, order and correct workspace
                updates = {}
                if layer.nombre_display != nombre_display:
                    updates['nombre_display'] = nombre_display
                if layer.orden != orden:
                    updates['orden'] = orden
                if layer.store_geoserver != store:
                    updates['store_geoserver'] = store
                if layer.metadata_id != metadata_id:
                    updates['metadata_id'] = metadata_id
                if updates:
                    for k, v in updates.items():
                        setattr(layer, k, v)
                    layer.save(update_fields=list(updates.keys()))


def reverse_func(apps, schema_editor):
    # No-op: data migration not reverted
    pass


class Migration(migrations.Migration):

    dependencies = [
        ('projects', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(forwards_func, reverse_func),
    ]
